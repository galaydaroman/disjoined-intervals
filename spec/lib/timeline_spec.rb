describe Timeline do
  let(:intervals) { [] }

  subject(:timeline) do
    described_class.new.tap do |obj|
      intervals.each { |(from, to)| obj.add(from, to) }
    end
  end

  it { is_expected.to be_empty }

  context '#add' do
    context 'new interval to empty timeline' do
      before { timeline.add(0, 10) }

      its(:to_a) { is_expected.to eq [[0, 10]] }
    end

    context 'interval without overlap' do
      let(:intervals) { [[0, 10]] }

      before { timeline.add(12, 14) }

      its(:to_a) { is_expected.to eq [[0, 10], [12, 14]] }
    end

    context 'interval with one overlap' do
      let(:intervals) { [[0, 10]] }

      before { timeline.add(5, 20) }

      its(:to_a) { is_expected.to eq [[0, 20]] }
    end

    context 'interval with two overlaps' do
      let(:intervals) { [[0, 10], [12, 15]] }

      before { timeline.add(5, 20) }

      its(:to_a) { is_expected.to eq [[0, 20]] }
    end

    context 'insert interval and sort them' do
      let(:intervals) { [[0, 10], [30, 40]] }

      before { timeline.add(15, 20) }

      its(:to_a) { is_expected.to eq [[0, 10], [15, 20], [30, 40]] }
    end

    context 'insert interval to the beginning' do
      let(:intervals) { [[0, 10], [30, 40]] }

      before { timeline.add(-25, -20) }

      its(:to_a) { is_expected.to eq [[-25, -20], [0, 10], [30, 40]] }
    end

    context 'insert interval to the end' do
      let(:intervals) { [[0, 10], [30, 40]] }

      before { timeline.add(100, 120) }

      its(:to_a) { is_expected.to eq [[0, 10], [30, 40], [100, 120]] }
    end

    context 'insert interval with floats' do
      let(:intervals) { [[0, 5]] }

      before { timeline.add(10.5, 11.2) }

      its(:to_a) { is_expected.to eq [[0, 5], [10.5, 11.2]] }
    end

    context 'method return self instance' do
      subject { timeline.add(1, 2) }

      it { is_expected.to eq timeline }
    end
  end

  context '#remove' do
    context 'interval without overlaps' do
      before { timeline.remove(1, 10) }

      its(:to_a) { is_expected.to be_empty }
    end

    context 'interval with one overlap' do
      let(:intervals) { [[0, 5]] }

      before { timeline.remove(0, 100) }

      its(:to_a) { is_expected.to be_empty }
    end

    context 'interval with two overlaps' do
      let(:intervals) { [[0, 5], [20, 25]] }

      before { timeline.remove(0, 22) }

      its(:to_a) { is_expected.to eq [[22, 25]] }
    end

    context 'interval with three overlaps' do
      let(:intervals) { [[0, 5], [20, 25], [50, 60]] }

      before { timeline.remove(1, 55) }

      its(:to_a) { is_expected.to eq [[0, 1], [55, 60]] }
    end

    context 'from in a middle of interval' do
      let(:intervals) { [[0, 25]] }

      before { timeline.remove(10, 12) }

      its(:to_a) { is_expected.to eq [[0, 10], [12, 25]] }
    end

    context 'whole timeline' do
      let(:intervals) { [[0, 25], [30, 45], [60, 70], [90, 100]] }

      before { timeline.remove(0, 100) }

      its(:to_a) { is_expected.to be_empty }
    end

    context 'interval with floats' do
      let(:intervals) { [[2, 10]] }

      before { timeline.remove(1.5, 7.75) }

      its(:to_a) { is_expected.to eq [[7.75, 10]] }
    end

    context 'method return self instance' do
      subject { timeline.remove(1, 2) }

      it { is_expected.to eq timeline }
    end
  end

  context '#to_a' do
    subject { described_class.new }

    context 'when timeline empty' do
      its(:to_a) { is_expected.to be_empty }
    end

    context 'when timeline have intervals' do
      subject { super().add(1, 3).add(5, 6) }

      its(:to_a) { is_expected.to eq [[1, 3], [5, 6]] }
    end
  end

  context '#clone' do
    let(:intervals) { [[0, 5]] }

    subject { timeline.clone }

    it { is_expected.not_to eq timeline }
    its(:to_a) { is_expected.to eq [[0, 5]] }
  end
end
