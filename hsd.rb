class Hsd < Formula
  desc "hsd"
  version "1.24"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.24/hsd-darwin-arm64"
      sha256 "9e5f404a6d5b4d00e199df7dd7f7bda52f6695824533062c6f2fa42852d88607"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.24/hsd-darwin-amd64"
      sha256 "a19bd8e721fd47d8ffe797a1e5a6e381296ef8e82c6ce7f24356ff8dff33a5f2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.24/hsd-linux-arm64"
      sha256 "2c5255d8edd984a175f40b7a4353acfc949c857e83777d7e7d3f6e59aca4a584"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.24/hsd-linux-amd64"
      sha256 "a007c4ea4ca93220067ce625c1c04ceb500217b67f0ac92627f43b23e4692f71"
    end
  end

  def install
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    bin.install "hsd-#{os}-#{arch}" => "hsd"
  end

  def post_install
    config_path = File.expand_path("~/.hsd")
    unless File.exist?(config_path)
      opoo "No existing hsd config found. Run: hsd config init"
    end

    if OS.mac?
      recommended = ["awscli", "kubernetes-cli", "helm"]
    else
      # For Linux, the package names might be different
      recommended = ["awscli", "kubernetes-cli", "helm"]
    end

    missing = recommended.reject do |pkg|
      quiet_system "brew", "list", "--formula", pkg
    end
    
    unless missing.empty?
      ohai "Recommended Homebrew packages missing: #{missing.join(', ')}"
      ohai "You can install them with:"
      ohai "  brew install #{missing.join(' ')}"
    end
  end
end