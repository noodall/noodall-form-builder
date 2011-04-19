Before do
  defensio_dummy = double("defensio dummy")
  defensio_dummy.stub(:post_document) do
    [200, {"spaminess" => 0.2, "allow" => true}]
  end

  Noodall::FormResponse.stub(:defensio).and_return(defensio_dummy)
end
