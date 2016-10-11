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

Running the Tests
-----------------

* If you have configured the kernel yourself, ensure that the ib_srp and
  ib_srpt drivers have been built as kernel modules. Reconfigure, rebuild and
  reinstall the kernel if necessary.
* Install the following software packages if these have not yet been
  installed: fio, gcc-c++, make, multipath-tools or device-mapper-multipath,
  sg3_utils, srptools, e2fsprogs and xfsprogs.
* Configure multipathd such that it recognizes the SRP LUNs that will be
  created by this test suite. Merge the following into `/etc/multipath.conf`:

<span></span>

    devices {
        device {
            vendor       "LIO-ORG|SCST_BIO|FUSIONIO"
            product      ".*"
            features     "1 queue_if_no_path"
            path_checker tur
        }
    }

* Run `echo reconfigure | multipathd -k` if multipathd has already been started.
* Run `make`.
* Run `./run_tests`.



