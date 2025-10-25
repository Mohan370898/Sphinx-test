.. toctree::
   :maxdepth: 2
   :caption: Contents:

*****************************
Sphinx文档演示
*****************************

这篇文档的源代码仓库在GitHub上：`Sphinx-test`_，之后连接到readthedocs进行挂载。

.. _Sphinx-test: https://github.com/Mohan370898/Sphinx-test

=============================
Gitee和Github镜像同步
=============================

-------------------------------------
1. 获取 GitHub Personal Access Tokens
-------------------------------------

进入 GitHub，点击右上角头像，进入：Settings → Developer settings → 左边栏最下面Personal access tokens → Tokens (classic) → Generate new token

必须项：

* Token name: 可以写Gitee_mirror
* expiration: 看情况选择过期日期
* repo access: 选择这个token可以访问的repo
* permissions: 点击add permissions，需要进一步对需要的项目选择Read and write

-----------------------------------------------
2.已有的Gitee仓库设置已有的GitHub仓库为镜像
-----------------------------------------------

.. image:: images/gitee-github.png

仓库上方管理 -> 左边栏仓库镜像管理 -> 添加镜像

* 镜像方向：Gitee Push到 GitHub
* 镜像仓库：选择要设置为镜像的GitHub仓库
* 私人令牌：上一步中获取到的有权限的Token

----------------------------------------------
3.镜像同步触发方式
----------------------------------------------

1. Gitee仓库有更新后会自动同步到GitHub仓库
2. 在Gitee的仓库镜像管理当中手动进行镜像更新

单次同步时间为5-30分钟左右

====================================================
Doxygen->Breathe->Sphinx 网页说明文档生成
====================================================

----------------------------------------------
简介
----------------------------------------------

Doxygen是命令行工具，Sphinx和Breathe是Python的包。在PMSL程序说明文档的开发中，Doxygen将利用源代码中的程序生成接口说明（xml文件），Breathe可以连接Doxygen的xml文件到Sphinx的rst语法中，Sphinx将对使用rst语法或markdown语法的文档进行编译，生成对应的html文档。

**Q**：为什么不直接使用Doxygen自动生成的文档
**A**：Doxygen是更偏向于撰写API接口的工具，相比于源代码内部，更关注程序的输入和输出参数。但是对于PMSL的程序，需要对代码的逻辑、过程进行详细说明

----------------------------------------------
文件结构树
----------------------------------------------

.. code-block:: bash

   :linenos:

   .
   ├── Makefile                       # Linux/macOS 一键构建入口
   ├── make.bat                       # Windows 一键构建入口
   ├── README.md                      # 项目说明文档│
   └── source/
      ├── _doxygen/
      │   └── xml/  # Doxygen 生成的 XML 文件目录（供 Breathe 使用）
      ├── Doxyfile                   # Doxygen 配置文件
      ├── conf.py                    # Sphinx 配置文件
      ├── index.rst                  # Sphinx 文档首页
      └── physics.f90                # Fortran 示例源代码

----------------------------------------------
使用方法
----------------------------------------------

**环境安装**
.. code-block:: bash

   :linenos:

   # 必需
   pip install sphinx
   pip install graphviz
   pip install breathe
   sudo apt-get install deoxygen
   # 可选，推荐安装
   pip install sphinx_rtd_theme # Sphinx的rtd主题
   pip install myst-parser # Sphinx markdown支持包
   pip install sphinxcontrib.katex # 使用katex渲染公式

**环境搭建**

.. code-block:: bash
   
   :linenos:

   sphinx-quickstart

之后根据系统提问回答，搭建好基础环境（包含文件结构树中的大部分内容）

**网页构建**

.. code-block:: bash

   :linenos:

   doxygen source/Doxyfile
   make html

----------------------------------------------
参考配置文件（便于host到readthedocs的版本）
----------------------------------------------

**Doxyfile**

.. code-block:: Makefile

   :linenos:

   # 基本
   PROJECT_NAME           = "Fortran Coulomb Force (Doxygen Demo)"
   OUTPUT_DIRECTORY       = _doxygen
   GENERATE_HTML          = NO
   GENERATE_LATEX         = NO
   GENERATE_XML           = YES
   XML_OUTPUT             = xml
   RECURSIVE              = YES

   # 输入
   INPUT                  = . README.md
   FILE_PATTERNS          = *.f90 *.F90 *.md
   EXTENSION_MAPPING      = f90=Fortran
   OPTIMIZE_FOR_FORTRAN   = YES
   EXTRACT_ALL            = YES
   EXTRACT_PRIVATE        = YES
   EXTRACT_STATIC         = YES
   SOURCE_BROWSER         = YES
   INLINE_SOURCES         = YES

   # 注释样式与外观
   JAVADOC_AUTOBRIEF      = YES
   WARN_IF_UNDOCUMENTED   = NO
   WARN_IF_DOC_ERROR      = YES
   GENERATE_TREEVIEW      = YES
   MARKDOWN_SUPPORT     = YES
   USE_MATHJAX          = YES
   HAVE_DOT	     = YES

**conf.py**

.. code-block:: python

   :linenos:

   # Configuration file for the Sphinx documentation builder.
   #
   # For the full list of built-in configuration values, see the documentation:
   # https://www.sphinx-doc.org/en/master/usage/configuration.html

   # -- Project information -----------------------------------------------------
   # https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

   import os,subprocess

   project = 'Sphinx Test'
   copyright = '2025, Zhe Liu'
   author = 'Zhe Liu'

   # -- General configuration ---------------------------------------------------
   # https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

   HERE = os.path.dirname(__file__)
   subprocess.run(["doxygen", os.path.join(HERE, "Doxyfile")], check=True)

   extensions = [
      "sphinx_rtd_theme",
      "breathe",
      "myst_parser",
      "sphinxcontrib.katex",
      "sphinx.ext.graphviz"
      ]

   breathe_projects = {"Sphinx test": os.path.join("_doxygen", "xml")}
   breathe_default_project = "Sphinx test"

   templates_path = ['_templates']
   exclude_patterns = ["sphinx_rtd_theme"]

   ketex_prerender = True



   # -- Options for HTML output -------------------------------------------------
   # https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

   html_theme = "sphinx_rtd_theme"
   html_static_path = ['_static']

   breathe_default_members = ()

**.readthedocs.yaml**

.. code-block:: yaml

   :linenos:

   build:
  os: ubuntu-24.04
  tools:
    python: "3.11"
  apt_packages:
    - doxygen
    - graphviz

sphinx:
  configuration: source/conf.py

python:
  install:
  - requirements: requirements.txt

**index.rst**（主页源文件）

.. code-blockl:: rst

   :linenos:

   .. Sphinx Test documentation master file, created by
      sphinx-quickstart on Thu Oct 23 11:27:58 2025.
      You can adapt this file completely to your liking, but it should at least
      contain the root `toctree` directive.

   Sphinx 演示
   ===================================

   .. toctree::
      :maxdepth: 2
      :caption: Contents:

   .. warning::
      这是一个警告！
      
   .. toctree::
      :maxdepth: 2
      :caption: Contents:

   physics.f90 说明
   ----------

   .. doxygenfile:: physics.f90
      :project: Sphinx test
      :sections: briefdescription detaileddescription program

   coulomb_force function说明
   ~~~~~~~~~~~~~~~~~~

   .. doxygenfunction:: coulomb_force
      :project: Sphinx test

   physics namespace 说明
   ~~~~~~~~~~~~~~~~~~~~
   .. doxygennamespace:: physics
      :project: Sphinx test
      :members:

   004 pusher
   ==============


   005 pusher2
   ==========

====================================================
readthedocs （网页host平台）
====================================================

*****************************
Doxygen文档引用演示
*****************************

.. warning::
   这是一个警告！
   
.. toctree::
   :maxdepth: 2
   :caption: Contents:

=====================
physics.f90 说明
=====================
这里通过使用``Breathe``引用了``Doxygen``产生的``.xml``文件，来对``physics.f90``文件进行说明。即：

.. code-block:: rst
   
   :linenos:

   .. doxygenfile:: physics.f90
      :project: Sphinx test

以下是``physics.f90``的文件说明

.. doxygenfile:: physics.f90
   :project: Sphinx test