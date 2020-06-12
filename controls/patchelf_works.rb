title 'Tests to confirm patchelf binary works as expected'

base_dir = input("base_dir", value: "bin")
plan_origin = ENV['HAB_ORIGIN']
plan_name = input("plan_name", value: "patchelf")
plan_ident = "#{plan_origin}/#{plan_name}"

control 'core-plans-patchelf' do
  impact 1.0
  title 'Ensure patchelf binary is working as expected'
  desc '
We first check that the patchelf binary we expect is present and then run a version check to verify that it is excecutable.
  '

  hab_pkg_path = command("hab pkg path #{plan_ident}")
  describe hab_pkg_path do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stderr') { should be_empty}
  end

  target_dir = File.join(hab_pkg_path.stdout.strip, base_dir)

  patchelf_exists = command("ls #{File.join(target_dir, "patchelf")}")
  describe patchelf_exists do
    its('stdout') { should match /patchelf/ }
    its('stderr') { should be_empty }
    its('exit_status') { should eq 0 }
  end

  patchelf_works = command("/bin/patchelf --version")
  describe patchelf_works do
    its('stdout') { should match /patchelf [0-9]+.[0-9]+/ }
    its('stderr') { should be_empty }
    its('exit_status') { should eq 0 }
  end
end
