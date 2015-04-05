require 'serverspec'
require 'docker'
require 'pry'

describe 'apt-check.sh' do

  shared_examples 'apt-check' do
    describe 'machine readable output' do
      let(:apt_check) { command('apt-check -s') }

      it 'returns the correct output' do
        expect(apt_check.stderr.chomp).to eq "#{updates};#{security_updates}"
      end

      it 'exits with the number of security packages' do
        expect(apt_check.exit_status).to eq security_updates
      end

      describe 'fussy' do
        let(:apt_check) { command('apt-check -sf') }

        it 'exits with all package upgrades' do
          expect(apt_check.exit_status).to eq updates
        end
      end
    end

    describe 'quiet' do
      let(:apt_check) { command('apt-check -sq') }

      it 'has no output if there are no updates' do
        if security_updates == 0
          expect(apt_check.stderr).to eq ""
        else
          expect(apt_check.stderr.chomp).to eq "#{updates};#{security_updates}"
        end
      end
    end

    describe 'human readable output' do
      let(:apt_check) { command('apt-check -sh') }

      it 'returns the correct output' do
        expect(apt_check.stderr.chomp).to eq "#{updates} packages can be updated.\n#{security_updates} updates are security updates."
      end

      it 'exits with the number of security packages' do
        expect(apt_check.exit_status).to eq security_updates
      end

      describe 'fussy' do
        let(:apt_check) { command('apt-check -sfh') }

        it 'exits with all package upgrades' do
          expect(apt_check.exit_status).to eq updates
        end
      end

      describe 'without skiping update' do
        let(:apt_check) { command('apt-check -f') }

        it 'exits with a non zero status' do
          expect(apt_check.exit_status).to be > 0
        end
      end

      describe 'cleanup' do
        let(:apt_check) { command('apt-check -c') }

        it 'cleans up the files in /var/lib/apt/lists/' do
          expect(apt_lists).to_not be_empty
          apt_check.stdout
          expect(apt_lists).to be_empty
        end
      end
    end
  end

  def apt_lists
    command('ls /var/lib/apt/lists/').stdout.split("\n")
  end

  describe 'ubuntu trusty' do

    before(:all) do
      setup 'trusty'
    end

    after(:all) do
      teardown
    end

    let(:updates)          { 6 }
    let(:security_updates) { 3 }

    it_behaves_like 'apt-check'

  end

  describe 'ubuntu trusty clean' do

    before(:all) do
      setup 'trusty-clean'
    end

    after(:all) do
      teardown
    end

    let(:updates)          { 0 }
    let(:security_updates) { 0 }

    it_behaves_like 'apt-check'

  end

  describe 'ubuntu precise' do

    before(:all) do
      setup 'precise'
    end

    after(:all) do
      teardown
    end

    let(:updates)          { 3 }
    let(:security_updates) { 3 }

    it_behaves_like 'apt-check'

  end

  describe 'ubuntu precise-clean' do

    before(:all) do
      setup 'precise-clean'
    end

    after(:all) do
      teardown
    end

    let(:updates)          { 0 }
    let(:security_updates) { 0 }

    it_behaves_like 'apt-check'

  end

  describe 'debian wheezy' do

    before(:all) do
      setup 'wheezy'
    end

    after(:all) do
      teardown
    end

    let(:updates)          { 14 }
    let(:security_updates) { 9 }

    it_behaves_like 'apt-check'

  end

  describe 'debian wheezy clean' do

    before(:all) do
      setup 'wheezy-clean'
    end

    after(:all) do
      teardown
    end

    let(:updates)          { 0 }
    let(:security_updates) { 0 }

    it_behaves_like 'apt-check'

  end

  describe 'debian jessie' do

    before(:all) do
      setup 'jessie'
    end

    after(:all) do
      teardown
    end

    let(:updates)          { 14 }
    let(:security_updates) { 9 }

    it_behaves_like 'apt-check'

  end

  describe 'debian jessie clean' do

    before(:all) do
      setup 'jessie-clean'
    end

    after(:all) do
      teardown
    end

    let(:updates)          { 0 }
    let(:security_updates) { 0 }

    it_behaves_like 'apt-check'

  end

  shared_examples 'apt-check without security repository' do
    describe 'machine readable output' do
      let(:apt_check) { command('apt-check -s') }

      it 'returns the correct output' do
        expect(apt_check.stderr.chomp).to eq "#{updates}"
      end

      it 'exits with the number of updates' do
        expect(apt_check.exit_status).to eq updates
      end

      describe 'fussy' do
        let(:apt_check) { command('apt-check -sf') }

        it 'exits with the number of updates' do
          expect(apt_check.exit_status).to eq updates
        end
      end
    end

    describe 'quiet' do
      let(:apt_check) { command('apt-check -sq') }

      it 'has no output if there are no updates' do
        if updates == 0
          expect(apt_check.stderr).to eq ""
        else
          expect(apt_check.stderr.chomp).to eq "#{updates}"
        end
      end
    end

    describe 'human readable output' do
      let(:apt_check) { command('apt-check -sh') }

      it 'returns the correct output' do
        expect(apt_check.stderr.chomp).to eq "#{updates} packages can be updated."
      end

      it 'exits with the number of security packages' do
        expect(apt_check.exit_status).to eq updates
      end

      describe 'fussy' do
        let(:apt_check) { command('apt-check -sfh') }

        it 'exits with all package upgrades' do
          expect(apt_check.exit_status).to eq updates
        end
      end

      describe 'without skiping update' do
        let(:apt_check) { command('apt-check -fh') }

        it 'exits with a non zero status' do
          expect(apt_check.exit_status).to be > 0
        end
      end

      describe 'cleanup' do
        let(:apt_check) { command('apt-check -c') }


        it 'cleans up the files in /var/lib/apt/lists/' do
          expect(apt_lists).to_not be_empty
          apt_check.stdout
          expect(apt_lists).to be_empty
        end
      end
    end
  end

  describe 'debian sid' do

    before(:all) do
      setup 'sid'
    end

    after(:all) do
      teardown
    end

    let(:updates)          { 70 }

    it_behaves_like 'apt-check without security repository'

  end

  describe 'debian sid clean' do

    before(:all) do
      setup 'sid-clean'
    end

    after(:all) do
      teardown
    end

    let(:updates)          { 0 }

    it_behaves_like 'apt-check without security repository'

  end

  def setup(os)
    File.write('Dockerfile',"FROM quay.io/assemblyline/apt-check.sh-testing:#{os}\nCOPY apt-check.sh /usr/local/bin/apt-check")
    @image = Docker::Image.build_from_dir(".")
    File.delete 'Dockerfile'
    Specinfra::Backend::Docker.instance_variable_set(:@instance, nil)
    set :backend, :docker
    set :docker_image, @image.id
  end

  def teardown
    Specinfra::Backend::Docker.instance.instance_variable_get(:@container).delete(force: true)
    @image.remove(force: true)
  end

end
