defmodule ExWeb3EcRecoverTest do
  use ExUnit.Case


  alias ExWeb3EcRecover.SignedType.Message
  # alias EthereumSignatures, as: ExWeb3EcRecover
  # doctest ExWeb3EcRecover
  doctest EthereumSignatures

  @domain %{
    "name" => "example.metamask.io",
    "version" => "4",
    "chainId" => 1,
    "verifyingContract" => "0x0000000000000000000000000000000000000000"
  }

  @expected_address "0x5ff3cb18d8866541c66e4a346767a10480c4278d"

  describe "recover_typed_signature/3" do
    test "Recovers address from a signature and the message" do
      # This sig was genarated using Meta Mask
      sig =
        "0x97ffd15a08cbaebf4cbf2cd40f704bb5b79e3e3a47e29c90f0d8b5360ef312ba0382885309a88c99832082241675b402bfc631e24554079cbee2d8b70a3caeb71b"

      message = %Message{
        types: %{
          "Message" => [%{"name" => "data", "type" => "string"}]
        },
        primary_type: "Message",
        message: %{
          "data" => "test"
        },
        domain: @domain
      }

      assert @expected_address ==
               EthereumSignatures.recover_typed_signature(message, sig, :v4)
    end

    test "Recovers address from a signature and the message with precalculated domain" do
      # This sig was genarated using Meta Mask
      sig =
        "0x97ffd15a08cbaebf4cbf2cd40f704bb5b79e3e3a47e29c90f0d8b5360ef312ba0382885309a88c99832082241675b402bfc631e24554079cbee2d8b70a3caeb71b"

      message = %Message{
        types: %{
          "Message" => [%{"name" => "data", "type" => "string"}]
        },
        primary_type: "Message",
        message: %{
          "data" => "test"
        },
        domain: "0x60b65550349ac7d938f53ce6675638066d55afa9f7dd6db452a10139fca6d0a2"
      }

      assert @expected_address ==
               EthereumSignatures.recover_typed_signature(message, sig, :v4)
    end

    test "Order message support" do
      message = %Message{
        types: %{
          "Order" => [
            %{"name" => "makerAddress", "type" => "address"},
            %{"name" => "takerAddress", "type" => "address"},
            %{"name" => "feeRecipientAddress", "type" => "address"},
            %{"name" => "senderAddress", "type" => "address"},
            %{"name" => "makerAssetAmount", "type" => "uint256"},
            %{"name" => "takerAssetAmount", "type" => "uint256"},
            %{"name" => "makerFee", "type" => "uint256"},
            %{"name" => "takerFee", "type" => "uint256"},
            %{"name" => "expirationTimeSeconds", "type" => "uint256"},
            %{"name" => "salt", "type" => "uint256"},
            %{"name" => "makerAssetData", "type" => "bytes"},
            %{"name" => "takerAssetData", "type" => "bytes"},
            %{"name" => "makerFeeAssetData", "type" => "bytes"},
            %{"name" => "takerFeeAssetData", "type" => "bytes"}
          ]
        },
        primary_type: "Order",
        domain: %{
          "name" => "0x Protocol",
          "version" => "3.0.0",
          "chainId" => 137,
          "verifyingContract" => "0xfede379e48c873c75f3cc0c81f7c784ad730a8f7"
        },
        message: %{
          "makerAddress" => "0x1bbeb0a1a075d870bed8c21dfbe49a37015e4124",
          "takerAddress" => "0x0000000000000000000000000000000000000000",
          "senderAddress" => "0x0000000000000000000000000000000000000000",
          "feeRecipientAddress" => "0x0000000000000000000000000000000000000000",
          "expirationTimeSeconds" => 1_641_635_545,
          "salt" => 1,
          "makerAssetAmount" => 1,
          "takerAssetAmount" => 50_000_000_000_000_000,
          "makerAssetData" =>
            "0x02571792000000000000000000000000a5f1ea7df861952863df2e8d1312f7305dabf2150000000000000000000000000000000000000000000000000000000000002b5b",
          "takerAssetData" =>
            "0xf47261b00000000000000000000000007ceb23fd6bc0add59e62ac25578270cff1b9f619",
          "takerFeeAssetData" => "0x",
          "makerFeeAssetData" => "0x",
          "takerFee" => 0,
          "makerFee" => 0
        }
      }

      sig =
        "0xe1170c9a9da6b19f579e6d9dce8b577ab577bc73bd247658b77a9846c2b4d3e51e882c9c7364b1e8bcf98b865b72ef835fd4dfe6b883ab6deb41fabe5252cc931c"

      assert @expected_address == EthereumSignatures.recover_typed_signature(message, sig, :v4)
    end

    test "tests hash message" do
      # This sig was genarated using Meta Mask

      msg = %Message{
        types: %{
          "Order" => [
            %{"name" => "makerAddress", "type" => "address"},
            %{"name" => "takerAddress", "type" => "address"},
            %{"name" => "feeRecipientAddress", "type" => "address"},
            %{"name" => "senderAddress", "type" => "address"},
            %{"name" => "makerAssetAmount", "type" => "uint256"},
            %{"name" => "takerAssetAmount", "type" => "uint256"},
            %{"name" => "makerFee", "type" => "uint256"},
            %{"name" => "takerFee", "type" => "uint256"},
            %{"name" => "expirationTimeSeconds", "type" => "uint256"},
            %{"name" => "salt", "type" => "uint256"},
            %{"name" => "makerAssetData", "type" => "bytes"},
            %{"name" => "takerAssetData", "type" => "bytes"},
            %{"name" => "makerFeeAssetData", "type" => "bytes"},
            %{"name" => "takerFeeAssetData", "type" => "bytes"}
          ]
        },
        primary_type: "Order",
        domain: %{
          "name" => "0x Protocol",
          "version" => "3.0.0",
          "chainId" => 137,
          "verifyingContract" => "0xfede379e48c873c75f3cc0c81f7c784ad730a8f7"
        },
        message: %{
          "makerAddress" => "0x1bbeb0a1a075d870bed8c21dfbe49a37015e4124",
          "takerAddress" => "0x0000000000000000000000000000000000000000",
          "senderAddress" => "0x0000000000000000000000000000000000000000",
          "feeRecipientAddress" => "0x0000000000000000000000000000000000000000",
          "expirationTimeSeconds" => 1_641_627_054,
          "salt" => 1,
          "makerAssetAmount" => 1,
          "takerAssetAmount" => 50_000_000_000_000_000,
          "makerAssetData" =>
            "0x02571792000000000000000000000000a5f1ea7df861952863df2e8d1312f7305dabf2150000000000000000000000000000000000000000000000000000000000002b5b",
          "takerAssetData" =>
            "0xf47261b00000000000000000000000007ceb23fd6bc0add59e62ac25578270cff1b9f619",
          "takerFeeAssetData" =>
            "0xf47261b00000000000000000000000007ceb23fd6bc0add59e62ac25578270cff1b9f619",
          "makerFeeAssetData" =>
            "0xf47261b00000000000000000000000007ceb23fd6bc0add59e62ac25578270cff1b9f619",
          "takerFee" => 0,
          "makerFee" => 0
        }
      }

      encrypted =
        ExWeb3EcRecover.RecoverSignature.hash_eip712(msg)
        |> Base.encode16(case: :lower)

      assert "0x493c8aaeec442571358fb4f5c39284a0f3ca40443c2e5ba693eea4615349fcf4" ==
               "0x" <> encrypted
    end

    test "Return {:error, :unsupported_version} when version is invalid" do
      # This sig was genarated using Meta Mask
      sig =
        "0xf6cda8eaf5137e8cc15d48d03a002b0512446e2a7acbc576c01cfbe40ad" <>
          "9345663ccda8884520d98dece9a8bfe38102851bdae7f69b3d8612b9808e6" <>
          "337801601b"

      message = %Message{
        types: %{
          "Message" => [%{"name" => "data", "type" => "string"}]
        },
        primary_type: "Message",
        message: %{
          "data" => "test"
        },
        domain: %{}
      }

      assert {:error, :unsupported_version} ==
               EthereumSignatures.recover_typed_signature(message, sig, :v5)
    end

    test "Return {:error, :invalid_signature} when signature is invalid" do
      sig = "invalid_sig"

      message = %Message{
        types: %{
          "Message" => [%{"name" => "data", "type" => "string"}],
          "EIP712Domain" => []
        },
        primary_type: "Message",
        message: %{
          "data" => "test"
        },
        domain: %{}
      }

      assert {:error, :invalid_signature} ==
               EthereumSignatures.recover_typed_signature(message, sig, :v4)
    end
  end

  describe "recover_personal_signature/2" do
    test "Recover address from signature when signature is valid" do
      signature =
        "0xaa69ef02d4c01b5014187a5838a00a94176505c4efb9d814d7c2179c090efc361" <>
          "c219e3849d0b996064bd28732faeefa8e303e85787171e18489cb97b1d75fd01b"

      message = "some message"

      expected_address = "0x2ff0416047e1a6c06dd2eb0195c984c787adf735"

      assert expected_address == EthereumSignatures.recover_personal_signature(message, signature)
    end

    test "Return {:error, :invalid_signature} when signature is invalid" do
      signature = "some invalid signature"

      message = "some message"

      assert {:error, :invalid_signature} ==
               EthereumSignatures.recover_personal_signature(message, signature)
    end
  end


end
