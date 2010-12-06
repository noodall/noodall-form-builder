Before do
  defensio_dummy = double("defensio dummy")
  defensio_dummy.stub(:post_document){ [200, {:spaminess => 0.2}] }

  Noodall::FormResponse.stub(:defensio).and_return(defensio_dummy)
end
