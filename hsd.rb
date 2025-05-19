class Hsd < Formula
  desc "hsd"
  version "1.5"

  on_arm do
    url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.5/hsd-arm64"
    sha256 "7cf121fe6a0e420a79ed42954533051899381c5c3c677919161f9a62675bf32e"
  end

  on_intel do
    url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.5/hsd-amd64"
    sha256 "dcffc22f8db030b8c9e37ab12c15b8ee994be0ab02ad142b02c9eb1e0f998c9e"
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    bin.install "hsd-#{arch}" => "hsd"
  end

  def post_install
    config_path = File.expand_path("~/.hsd")
    unless File.exist?(config_path)
      opoo "No existing hsd config found. Run: hsd config init"
    end

    recommended = ["awscli", "kubernetes-cli", "helm"]
    null_device = defined?(File::NULL) ? File::NULL : "/dev/null"
    missing = recommended.reject do |pkg|
      system("brew", "list", pkg, out: null_device, err: null_device)
    end
    unless missing.empty?
      ohai "Recommended Homebrew packages missing: #{missing.join(', ')}"
      ohai "You can install them with:"
      puts "  brew install #{missing.join(' ')}"
    end
  end
end