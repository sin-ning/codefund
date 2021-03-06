defmodule AdService.Query.ForAudienceCreationTest do
  use CodeFund.DataCase
  import CodeFund.Factory

  setup do
    insert(:audience, %{
      programming_languages: ["Ruby", "C"],
      topic_categories: ["Programming"]
    })

    insert(:audience, %{
      programming_languages: ["Java", "C"],
      topic_categories: ["Development"]
    })

    property =
      insert(:property, %{
        programming_languages: ["Ruby", "C"],
        topic_categories: ["Programming"]
      })

    property_2 =
      insert(:property, %{
        programming_languages: ["Java"],
        topic_categories: ["Making de internetz"]
      })

    insert(:property, %{
      programming_languages: ["Ruby", "C"],
      topic_categories: ["Development"]
    })

    property_3 =
      insert(:property, %{
        programming_languages: ["C"],
        topic_categories: ["Development"]
      })

    insert_list(10, :impression, property: property, inserted_at: Timex.now())

    insert_list(
      10,
      :impression,
      property: property,
      country: "US",
      inserted_at:
        Timex.shift(Timex.now(), months: -1) |> Timex.beginning_of_month() |> Timex.shift(days: 1)
    )

    insert_list(
      10,
      :impression,
      property: property,
      country: "CN",
      inserted_at:
        Timex.shift(Timex.now(), months: -1) |> Timex.beginning_of_month() |> Timex.shift(days: 1)
    )

    insert(
      :impression,
      property: property,
      ip: "10.20.30.40",
      country: "US",
      inserted_at:
        Timex.shift(Timex.now(), months: -1) |> Timex.beginning_of_month() |> Timex.shift(days: 1)
    )

    insert_list(
      10,
      :impression,
      property: property_2,
      inserted_at:
        Timex.shift(Timex.now(), months: -1) |> Timex.beginning_of_month() |> Timex.shift(days: 1)
    )

    insert_list(
      10,
      :impression,
      property: property_3,
      inserted_at:
        Timex.shift(Timex.now(), months: -1) |> Timex.beginning_of_month() |> Timex.shift(days: 1)
    )

    {:ok, %{}}
  end

  describe "metrics" do
    test "it returns the count of properties and counts of impressions and unique users for the last month that will be targeted by the defined audience" do
      assert AdService.Query.ForAudienceCreation.metrics(
               included_countries: ["US"],
               programming_languages: ["Java"],
               topic_categories: ["Programming"]
             ) == %{
               "impression_count" => 41,
               "property_count" => 2,
               "unique_user_count" => 2
             }
    end

    test "it raises if included_countries isn't set" do
      assert_raise FunctionClauseError, fn ->
        AdService.Query.ForAudienceCreation.metrics(
          programming_languages: ["Ruby"],
          topic_categories: ["Programming"]
        )
      end
    end
  end
end
