defmodule ChirpWeb.PostLive.Index do
  use ChirpWeb, :live_view

  alias Chirp.Timeline
  alias Chirp.Timeline.Post

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Timeline.subscribe()

    # {:ok, assign(socket, :posts, list_posts()), temporary_assigns: [posts: []]}
    {:ok, assign(socket, :posts, list_posts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Timeline.get_post!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:post, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Timeline.get_post!(id)
    Timeline.delete_post(post)

    send(self(), {:post_deleted, post})

    # {:noreply, assign(socket, :posts, list_posts())}
    {:noreply, socket}
  end

  @impl true
  def handle_info({:post_created, post}, socket) do
    {:noreply, update(socket, :posts, fn posts -> [post | posts] end)}
  end

  @impl true
  def handle_info({:post_updated, post}, socket) do
    # Case 1 with manual update
    {:noreply, update(socket, :posts, fn posts ->
      Enum.map(posts, fn p ->
        case p.id == post.id do
          true -> post
          false -> p
        end
      end)
    end)}
    # Case 2 with prepend phx-update
    # {:noreply, update(socket, :posts, fn posts -> [post | posts] end)}
  end

  @impl true
  def handle_info({:post_deleted, post}, socket) do
    {:noreply, assign(socket, :posts, Enum.filter(socket.assigns.posts, fn p -> p.id != post.id end))}
  end

  defp list_posts do
    Timeline.list_posts()
  end
end
