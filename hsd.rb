class Hsd < Formula
  desc "hsd"
  version "1.3"

  on_arm do
    url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.3/hsd-arm64"
    sha256 "930cb4b260c56dbf9d58857a82010496c78cd92850b0aa291a84a12f82b54ca4"
  end

  on_intel do
    url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.3/hsd-amd64"
    sha256 "56fe356a2bf34dd131abad5a38476c5b3000e59145484ab89270f6ce74cd2586"
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    bin.install "hsd-#{arch}" => "hsd"
  end

  def post_install
    config_path = File.expand_path("~/.hsd")
    unless File.exist?(config_path)
      opoo "No existing hsd config found. run hsd config init"
    end

    recommended = ["awscli", "kubernetes-cli", "helm"]
    missing = recommended.reject { |pkg| system("brew", "list", pkg, out: File::NULL, err: File::NULL) }
    unless missing.empty?
      puts "Recommended Homebrew packages missing: #{missing.join(', ')}"
      puts "You can install them with:"
      puts "  brew install #{missing.join(' ')}"
    end
  end
end