defmodule Chirp.TimelineFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Chirp.Timeline` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        author: "some author",
        body: "some body",
        likes_count: 42,
        reposts_count: 42
      })
      |> Chirp.Timeline.create_post()

    post
  end
end
