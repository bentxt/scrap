(use-modules
  (guix packages)
  ((guix licenses) #:prefix license:)
  (guix download)
  (guix build-system gnu)
  (gnu packages)
  (gnu packages autotools)
  (gnu packages guile)
  (gnu packages guile-xyz)
  (gnu packages pkg-config)
  (gnu packages texinfo))

(package
  (name "guile-prescheme")
  (version "0.1-pre")
  (source "./guile-prescheme-0.1-pre.tar.gz")
  (build-system gnu-build-system)
  (arguments `())
  (native-inputs
    `(("autoconf" ,autoconf)
      ("automake" ,automake)
      ("pkg-config" ,pkg-config)
      ("texinfo" ,texinfo)))
  (inputs `(("guile" ,guile-3.0)))
  (propagated-inputs `())
  (synopsis
    "Guile port of Pre-Scheme, a Scheme-like systems language")
  (description
    "guile-prescheme is a port of the Pre-Scheme compiler from Scheme 48.  Pre-Scheme is a statically typed dialect of Scheme which offers the efficiency and low-level machine access of C while retaining many of the desirable features of Scheme.")
  (home-page
    "https://notabug.org/flatwhatson/guile-prescheme")
  (license license:bsd-3))

