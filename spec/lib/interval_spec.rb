describe Interval do
  subject(:interval) { described_class.new(1, 5) }

  context '#clone' do
    subject { interval.clone }

    it { is_expected.not_to eq(interval) }
    its(:from) { is_expected.to eq(interval.from) }
    its(:to) { is_expected.to eq(interval.to) }
  end

  context 'validation' do
    context 'when interval `to` is lower then `from`' do
      it 'should raise an error' do
        expect { described_class.new(10, 0) }.to raise_error(/Not valid interval/)
      end
    end

    context 'when interval `to` is equals then `from`' do
      it 'should raise an error' do
        expect { described_class.new(10, 10) }.to raise_error(/Not valid interval/)
      end
    end

    context 'when interval `to` is greater then `from`' do
      it 'should not raise an error' do
        expect { described_class.new(1, 10) }.not_to raise_error
      end
    end
  end

  context '#to_a' do
    its(:to_a) { is_expected.to eq [1, 5] }
  end

  context '<=> comparator' do
    subject { new_interval <=> interval }

    context 'when do NOT intersect' do
      context 'with interval which starts after' do
        let(:new_interval) { described_class.new(10, 12) }

        it { is_expected.to eq(3) }
      end

      context 'with interval which ends before' do
        let(:new_interval) { described_class.new(-1, 0) }

        it { is_expected.to eq(-3) }
      end
    end

    context 'when intersect with each other' do
      context 'and first interval starts before' do
        let(:new_interval) { described_class.new(-1, 1) }

        it { is_expected.to eq(-2) }
      end

      context 'but first interval includes range of another one' do
        let(:new_interval) { described_class.new(-10, 10) }

        it { is_expected.to eq(-1) }
      end

      context 'and equals' do
        let(:new_interval) { described_class.new(1, 5) }

        it { is_expected.to eq(0) }
      end

      context 'but second interval includes range of first one' do
        let(:new_interval) { described_class.new(2, 3) }

        it { is_expected.to eq(1) }
      end

      context 'and first interval starts after' do
        let(:new_interval) { described_class.new(4, 10) }

        it { is_expected.to eq(2) }
      end
    end
  end

  context '#add' do
    let(:another_interval) { described_class.new(from, to) }

    subject { interval.add(another_interval) }

    context 'merge interval from the left' do
      let(:from) { 0 }
      let(:to) { 2 }

      its(:from) { is_expected.to eq(0) }
      its(:to) { is_expected.to eq(5) }
    end

    context 'merge interval from the right' do
      let(:from) { 3 }
      let(:to) { 10 }

      its(:from) { is_expected.to eq(1) }
      its(:to) { is_expected.to eq(10) }
    end

    context 'merge interval which not overlaps' do
      let(:from) { 10 }
      let(:to) { 100 }

      it 'should raise an arror' do
        expect { subject }.to raise_error 'Cannot add intervals without intersection'
      end
    end

    context 'merge interval from both sides' do
      let(:from) { 0 }
      let(:to) { 10 }

      its(:from) { is_expected.to eq(0) }
      its(:to) { is_expected.to eq(10) }
    end

    context 'will create new instance of interval' do
      let(:from) { 0 }
      let(:to) { 2 }

      it { is_expected.not_to eq(interval) }
    end
  end

  context '#add!' do
    let(:another_interval) { described_class.new(0, 3) }

    subject { interval.add!(another_interval) }

    context 'will mutate existing instance of interval' do
      it { is_expected.to eq(interval) }
    end

    context 'merge with interval argument' do
      before do
        expect(interval).to receive(:add).and_call_original
      end

      its(:from) { is_expected.to eq(0) }
      its(:to) { is_expected.to eq(5) }
    end
  end

  context '#subtract' do
    let(:another_interval) { described_class.new(from, to) }

    subject { interval.subtract(another_interval) }

    context 'when intervals not overlaps' do
      let(:from) { 10 }
      let(:to) { 20 }

      it { is_expected.to have(1).interval }

      it 'should not change interval range' do
        expect(subject[0].from).to eq(1)
        expect(subject[0].to).to eq(5)
      end

      it 'should clone existing instance' do
        expect(subject[0]).not_to eq(interval)
      end
    end

    context 'when overlaps with left side of interval' do
      let(:from) { 0 }
      let(:to) { 3 }

      it { is_expected.to have(1).interval }

      it 'should change interval range' do
        expect(subject[0].from).to eq(3)
        expect(subject[0].to).to eq(5)
      end

      it 'should clone existing instance' do
        expect(subject[0]).not_to eq(interval)
      end
    end

    context 'when overlaps with right side of interval' do
      let(:from) { 3 }
      let(:to) { 10 }

      it { is_expected.to have(1).interval }

      it 'should change interval range' do
        expect(subject[0].from).to eq(1)
        expect(subject[0].to).to eq(3)
      end

      it 'should clone existing instance' do
        expect(subject[0]).not_to eq(interval)
      end
    end

    context 'when subtracting interval is subrange' do
      let(:from) { 3 }
      let(:to) { 4 }

      it { is_expected.to have(2).intervals }

      it 'first interval range' do
        expect(subject[0].from).to eq(1)
        expect(subject[0].to).to eq(3)
      end

      it 'second interval range' do
        expect(subject[1].from).to eq(4)
        expect(subject[1].to).to eq(5)
      end

      it 'should clone existing instance' do
        expect(subject[0]).not_to eq(interval)
        expect(subject[1]).not_to eq(interval)
      end
    end

    context 'when totally overlaps with bigger one interval' do
      let(:from) { 0 }
      let(:to) { 100 }

      it { is_expected.to be_empty }
    end
  end

  context '#intersect_with?' do
    let(:another_interval) { described_class.new(from, to) }

    subject { interval.intersect_with?(another_interval) }

    context 'when they are overlaps' do
      let(:from) { 5 }
      let(:to) { 10 }

      it { is_expected.to eq true }
    end

    context 'when they are not overlaps' do
      let(:from) { 25 }
      let(:to) { 50 }

      it { is_expected.to eq false }
    end
  end
end
