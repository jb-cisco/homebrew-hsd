class Hsdemo < Formula
    desc "hsd"
    version "1.0"
    url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.0/hsd" 
    # List of dependencies

  def install
    odie "This formula only supports ARM architecture today." unless Hardware::CPU.arm?
    # Proceed with installation
  end
  
  def install
    bin.install "hsd"
  end
end