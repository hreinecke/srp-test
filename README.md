Introduction
------------

The SRP initiator (ib_srp) and SRP target (ib_srpt) drivers interact with
several other kernel subsystems. The upstream ib_srpt target driver relies on
the LIO core and also on the Linux RDMA stack. The ib_srp initiator driver
makes use of the SRP transport layer, the SCSI core and the block layer
core. A large number of tests have to be run to test both drivers
thoroughly. Running these tests manually is tedious. Hence this test suite
that tests the SRP initiator and target drivers by loading both drivers on the
same server, by logging in using the IB loopback functionality and by sending
I/O through the SRP initiator driver to a RAM disk exported by the SRP target
driver.

Running the Tests on an IB Setup
--------------------------------

* If you have configured the kernel yourself, ensure that the ib_srp and
  ib_srpt drivers have been built as kernel modules. Reconfigure, rebuild and
  reinstall the kernel if necessary.
* Install the following software packages if these have not yet been
  installed: fio, gcc-c++, make, multipath-tools or device-mapper-multipath,
  sg3_utils, srptools, e2fsprogs and xfsprogs.
* Configure multipathd such that it recognizes the SRP LUNs that will be
  created by this test suite. Merge the following into `/etc/multipath.conf`:

<span></span>

    defaults {
        user_friendly_names     yes
        queue_without_daemon    no
        getuid_callout          "/.../srp-test/bin/getuid_callout %n"
    }
    devices {
        device {
            vendor       "LIO-ORG|SCST_BIO|FUSIONIO"
            product      ".*"
            features     "1 queue_if_no_path"
            path_checker tur
        }
    }
    blacklist_exceptions {
        property        ".*"
        devnode         "^nvme"
    }

* Start multipathd if it is not yet running.
* Run `echo reconfigure | multipathd -k` if multipathd has already been started.
* Run `make`.
* Run `./run_tests`.

Running the Tests on an Ethernet Setup
--------------------------------------

* Obtain the latest version of rdma_rxe, either by using kernel v4.11 or later
  or by merging the k.o/for-4.11 branch into your kernel tree of the following
  repository: https://git.kernel.org/cgit/linux/kernel/git/dledford/rdma.git
* If you have configured the kernel yourself, ensure that the software RDMA
  over Ethernet driver (rdma_rxe) driver is enabled. Reconfigure, rebuild and
  reinstall the kernel and boot the new kernel if necessary.
* Install the rdma-core software package (building and installing the entire
  package is not required):

<span></span>

    git clone https://github.com/linux-rdma/rdma-core &&
    sudo ln -s .../rdma-core/providers/rxe/rxe_cfg /usr/sbin/rxe_cfg

* Install the ib_srp-backport driver:

<span></span>

    git clone https://github.com/bvanassche/ib_srp-backport.git &&
    cd ib_srp-backport &&
    make &&
    sudo make install

* Install SCST:

<span></span>

    git clone https://github.com/bvanassche/scst.git &&
    cd scst &&
    make scst srpt &&
    sudo make -sC scst install &&
    sudo make -sC srpt install

* Configure at least one SoftRoCE interface, e.g. as follows:

<span></span>

    sudo modprobe rdma_rxe &&
    sudo rxe_cfg add eth0 &&
    sudo rxe_cfg &&

* Configure multipathd using the instructions from the previous section.
* Start multipathd if it is not yet running.
* Run `echo reconfigure | multipathd -k` if multipathd has already been started.
* Run `make`.
* Run `./run_tests -s`.
