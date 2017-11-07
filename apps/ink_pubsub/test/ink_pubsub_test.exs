defmodule InkPubSubTest do
  use ExUnit.Case

  describe "subscribe/1" do
    test "subscribes the current process to the give topic" do
      :ok = InkPubSub.subscribe("test")
      :ok = InkPubSub.direct_broadcast!("test", {:message, "TEST!!!"})

      assert_receive {:message, "TEST!!!"}
    end
  end

  describe "unsubscribe/1" do
    test "unsubscribes the current process from the give topic" do
      :ok = InkPubSub.subscribe("test")
      :ok = InkPubSub.unsubscribe("test")
      :ok = InkPubSub.direct_broadcast!("test", {:message, "TEST!!!"})

      refute_receive {:message, "TEST!!!"}
    end
  end
end
