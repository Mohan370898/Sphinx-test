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