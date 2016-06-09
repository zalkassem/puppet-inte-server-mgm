Puppet::Type.newtype(:mksuser) do
  @doc = "Manage an User for the PTC Integrity Server"

  ensurable

  newparam(:name, :namevar => true) do
    desc "The name of the user."
  end

end
