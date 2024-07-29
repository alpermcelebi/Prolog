:- module(main, [is_blogpost_written_by/2, has_post_in_topic/2, get_follower_count_of_blogger/2, get_post_count_of_topic/2, filter_posts_by_date/4, recommend_posts/2, recommend_bloggers/2]).
:- [kb].

% DO NOT CHANGE THE UPPER CONTENT, WRITE YOUR CODE AFTER THIS LINE

is_blogpost_written_by(BloggerNick, ShortPostName) :-
    posted(BloggerNick, PostID),
    blogpost(PostID, ShortPostName, _, _).

has_post_in_topic(BloggerNick, Topic) :-
    posted(BloggerNick, PostID),
    blogpost(PostID, _, Topic, _), !.

get_follower_count_of_blogger(BloggerNick, FollowerCount) :-
    findall(ReaderNick, follows(ReaderNick, BloggerNick), Followers),
    length(Followers, FollowerCount).

get_post_count_of_topic(Topic, PostCount) :-
    findall(PostID, blogpost(_, _, Topic, _), Posts),
    length(Posts, PostCount).

filter_posts_by_date(ListOfPostIDs, OldestDate, NewestDate, ListOfFilteredPostIDs) :-
    include(post_within_date_range(OldestDate, NewestDate), ListOfPostIDs, ListOfFilteredPostIDs).

post_within_date_range(OldestDate, NewestDate, PostID) :-
    blogpost(PostID, _, _, Date),
    Date >= OldestDate,
    Date =< NewestDate.

recommend_posts(ReaderNick, ListOfRecommendedPosts) :-
    reader(ReaderNick, ListOfInterestTopics),
    findall(PostID, (blogpost(PostID, _, Topic, _), member(Topic, ListOfInterestTopics), \+ alreadyread(ReaderNick, PostID)), RecommendedPosts),
    sort(RecommendedPosts, ListOfRecommendedPosts).

recommend_bloggers(ReaderNick, ListOfRecommendedBloggers) :-
    reader(ReaderNick, ListOfInterestTopics),
    findall(BloggerNick, (blogger(BloggerNick), \+ follows(ReaderNick, BloggerNick), has_relevant_post(BloggerNick, ListOfInterestTopics)), RecommendedBloggers),
    sort(RecommendedBloggers, ListOfRecommendedBloggers).

has_relevant_post(BloggerNick, ListOfInterestTopics) :-
    posted(BloggerNick, PostID),
    blogpost(PostID, _, Topic, _),
    member(Topic, ListOfInterestTopics), !.
