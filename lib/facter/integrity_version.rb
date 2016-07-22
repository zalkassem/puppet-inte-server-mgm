<<<<<<< HEAD
Facter.add(:integrity_version) do
  setcode do
    server_version = 'unknown'
    if output = Facter::Util::Resolution.exec('rpm -q --queryformat "%{Version}" ptc-integrity-server')
      server_version = output if /^[0-9]+.[0-9]+$/.match(output)
    end
    server_version
  end
end
