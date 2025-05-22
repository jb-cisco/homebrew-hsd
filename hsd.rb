class Hsd < Formula
  desc "hsd"
  version "1.13"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.13/hsd-darwin-arm64"
      sha256 "c10bb7a1def9f63be42b6dd0070eb459dc8dfe36fc30a985ca6ce57dec9c7cb8"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.13/hsd-darwin-amd64"
      sha256 "29d570e943e4deae1018a5513a25cfc06889b25530bdb20ee6b9c161df8449de"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.13/hsd-linux-arm64"
      sha256 "4f341b361cdf8f136746428aa06dde010f68208216cd35f35c8bd95dce89f732"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.13/hsd-linux-amd64"
      sha256 "806ec72b7ee23b4fd27d199c737197285bc0d904003a8cef844ace2ddb3165c9"
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