class Hsd < Formula
  desc "hsd"
  version "1.27"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.27/hsd-darwin-arm64"
      sha256 "7034814c99d4f50198bfba58bb4305b656fff4f0c5a025d448e54d1d9f15d839"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.27/hsd-darwin-amd64"
      sha256 "48377c31bd0569abe97e3c89fd98a6fbfed848abba15ac7fab1f0a3aa7ef73da"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.27/hsd-linux-arm64"
      sha256 "ece59d8fbd82a294679ea91812afedbcdb597dd1b27204af3164605a9aa69540"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.27/hsd-linux-amd64"
      sha256 "5c32847513d62feceb063117a6094d45ca335333df34d1663fcfb7d7ab3f906c"
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