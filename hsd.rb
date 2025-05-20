class Hsd < Formula
  desc "hsd"
  version "1.11"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.11/hsd-darwin-arm64"
      sha256 "a020b43b4581bbea3c2f59de9a0fdf117b3edf8b08afea2d546355d50247d094"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.11/hsd-darwin-amd64"
      sha256 "dfbaf2903d0d90a48f340e8f0ba6ec35c908a633c62fce3c70088b92cfae0101"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.11/hsd-linux-arm64"
      sha256 "58270772f5199017da54fc2a23176122f78bc3f8053541695d345886ce510d7b"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.11/hsd-linux-amd64"
      sha256 "e706faea566d12bbbf042e0a81796404afad54ccd03e07f528b9c11c4d60c835"
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