

==========================
Template OpenCMISS example
==========================

This repository is intended to serve as a guide for setting up an OpenCMISS example.  Consider looking at the branches in this repository for guidance on how different aspects that are not shown in this branch can be added to an example.  It is expected that the `barebones <https://github.com/OpenCMISS-Examples/template_example/tree/barebones>`_ branch will provide the best starting point for new examples.  One of the first tasks you should do is to replace the content in this README file with information on your example.

.. contents:: **Contents**
   :backlinks: entry

The `master <https://github.com/OpenCMISS-Examples/template_example/tree/master>`_ branch is an over annotated example structure of a standard example, for a bare bones example structure try the `barebones <https://github.com/OpenCMISS-Examples/template_example/tree/barebones>`_ branch of this repository.  Other branches that may be of interest are the `input_arguments <https://github.com/OpenCMISS-Examples/template_example/tree/input_arguments>`_ branch, `input_files <https://github.com/OpenCMISS-Examples/template_example/tree/input_files>`_ branch, `stdout <https://github.com/OpenCMISS-Examples/template_example/tree/stdout>`_ branch, and the `python <https://github.com/OpenCMISS-Examples/template_example/tree/python>`_ branch.

**Branches**

* `master <https://github.com/OpenCMISS-Examples/template_example/tree/master>`_
* `barebones <https://github.com/OpenCMISS-Examples/template_example/tree/barebones>`_
* `input_arguments <https://github.com/OpenCMISS-Examples/template_example/tree/input_arguments>`_
* `input_files <https://github.com/OpenCMISS-Examples/template_example/tree/input_files>`_
* `stdout <https://github.com/OpenCMISS-Examples/template_example/tree/stdout>`_
* `python <https://github.com/OpenCMISS-Examples/template_example/tree/python>`_

Directory structure
===================

The basic directory structure for an example is to have two child directories *docs* and *src*.  The *docs* directory contains the documentation on the example and the *src* directory contains the source code required to build the example.  The *src* directory can be further split into language subdirectories; *python*, *c*, *cxx*, *fortran*.  These are only required if that language is implemented by the example.

Basic example directory structure::

    .
    +-- docs
    +-- src
        +-- c
        +-- cxx
        +-- fortran
        +-- python


Example executable
==================

The example should create an executable that can be run, how we configure and build the executable will be explained in the the `CMake files` section.  The code required to create the executable is placed into the correspoding language directory inside the *src* directory.  For instance if we are creating a Fortran example with the code written in the file *ZZZZZZZZ.F90* this file belongs in *src/fortran*.

CMake files
===========

The CMake files describe how the example is to be configured and built.  The first CMakeLists.txt file that we add contains the minimum version of CMake that the example works with, the project statement where it is good practice to provide a version number for the example, the find package statement for finding the OpenCMISS libraries, and the sub-directory where the details of the executable are defined.  Below is how this all looks in the CMake language (also see the file *CMakeLists.txt* in the root directory).

Root *CMakeLists.txt* file::

  # Specify the minimum version of CMake, OpenCMISS itself requires
  # at least version 3.4 of CMake so that will also constrian the 
  # minimum version we are able to set here.  We can't continue if this
  # is not the case so we may as well stop right here.
  cmake_minimum_required(VERSION 3.4 FATAL_ERROR)
  
  # Declare the project name and version number and specify the languages
  # used.  We must specify the *C* language irrespective of whether we use 
  # it or not as it is required by MPI.
  project(XXXXXXXX-Example VERSION X.Y.Z LANGUAGES C Fortran)
  
  # Get CMake to find the OpenCMISS libraries.  Because the OpenCMISS libraries
  # are not usually available in the system directories we will have to 
  # specify where OpenCMISS libraries can be found.  We can do this through the
  # command line by setting the argument *OpenCMISSLibs_DIR* to the location
  # of the OpenCMISS libraries install directory.
  find_package(OpenCMISSLibs 1.3.0 REQUIRED CONFIG)
  
  # Add the subdirectory for further CMakeLists.txt files that define any
  # executables that are to be built.  Python examples do not have a configure
  # and build phase so CMake has no work to do thus we will not see any mention
  # of Python in the CMake files.
  add_subdirectory(src/fortran)

The above *CMakeLists.txt* is what we require for the example *XXXXXXXX* with version number *X.Y.Z* that defines a fortran executable.  Note we haven't yet defined the fortran executable we do that in another *CMakeLists.txt* file inside the *src/fortran* directory.  We could also add other languages here like *C* or *CXX* and we would then add another *add_subdirectory* command with the relative subdirectory as an argument for that language.  To carry on with our Fortran example we now need to define an executable.  We do this in the *src/fortran/CMakeLists.txt* file.

*src/fortran/CMakeLists.txt* file::

  # Define the executable and adding the source files required to build the application.
  # When we are defining fortran source files if we name the source files with the extension
  # .F90 (using a capital *F* and not a lowercase one) CMake will automatically run the *C*
  # preprocessor on the file for us, saving us from specifying that through other means.
  # This is only necessary if the file requires the the *C* preprocessor.
  add_executable(XXXXXXXX ZZZZZZZZ.F90)
  
  # Set the required libraries for this executable.  Here we let CMake know which libraries
  # are required to link the application.  Now because the *opencmisslibs* is known to CMake 
  # as a target, there is nothing else we need to do.  The *opencmisslibs* target contains
  # enough information for CMake to properly build and link the application with the OpenCMISS
  # libraries.
  #
  # While https://github.com/OpenCMISS/iron/issues/88 is not fixed we also need to specify that
  # MPI should also be linked into the application.  Once this issue is resolved we will no longer
  # be required to add this as a link library.  This only applies to examples making use of Iron, 
  # if the example is only using the Zinc library then MPI is not required at all.
  target_link_libraries(XXXXXXXX PUBLIC opencmisslibs mpi)


Inputs
======

If the example requries external inputs to be supplied these are stored in a directoy named *inputs*.  To specify the arguments required to run the executable write the arguments as a semi-colon separated list in a file named *arguments.cmake*.  The arguments specified in the *arguments.cmake* file and the inputs stored in the directory should match with the information stored in the *expected_results* section.  That is when the arguments taken from the *arguments.cmake* file are applied to the executable the output from the application should match what is in the *expected_results* directory to within some tolerance (when dealing with numerical values).

The *inputs* directory should be made a sub-directory of the language.  For example in a C++ example we would have the following directory structure::

    .
    +-- docs
    +-- src
        +-- cxx
            +-- inputs

Expected results
================

If the example has some expected results these are stored in a directory named *expected_results*.  If the example writes text to the standard output stream then this content should be captured in a *stdout.txt* file within the *expected_results* directory.

The *expected_results* directory should be made a sub-directory of the language.  For example in a Python example we would have the following directory structure::

    .
    +-- docs
    +-- src
        +-- python
            +-- expected_results

Documentation
=============

The documentation should be written in re-structured text a basic Sphinx configuration file is provided in the *docs* directory.  The documentation in the *docs* directory (which can be built with Sphinx) should be about the example and explain what the software does and what inputs are required (if any) to get the expected results and output from the application.  The README.rst file is documentation on how to use the example, use the `README.template.rst <README.template.rst>`_ as a starting point for putting together a README.rst for your own examples.
