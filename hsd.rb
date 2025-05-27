class Hsd < Formula
  desc "hsd"
  version "1.25"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.25/hsd-darwin-arm64"
      sha256 "a4cba22aa9e856bba65798230cfbbbd6e9bfb465c7d797061f20970186192f13"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.25/hsd-darwin-amd64"
      sha256 "3fe79da12e8fc597213ea993f46134f6e56ba66e870b656bd35f6727dd3774f8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.25/hsd-linux-arm64"
      sha256 "d823a9ede923a9b77af9269d79e865ad3ad65ff0652aa7199a18220a582dbf50"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.25/hsd-linux-amd64"
      sha256 "5003ee6335301655c5eae7134c68d8d4342e61cf9cc123e0301c3b58a227b906"
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