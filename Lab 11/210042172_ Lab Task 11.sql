SET SERVEROUTPUT ON SIZE 1000000;
SET VERIFY OFF;

-----1-----

-- Get Movie Time

CREATE OR REPLACE PROCEDURE Movie_Time(title IN VARCHAR2) IS
    movi_time NUMBER;
    hr NUMBER;
    mi NUMBER;
    factor NUMBER;
BEGIN
    SELECT mov_time INTO movi_time
    FROM Movie
    WHERE mov_title = title;

    factor := FLOOR(movi_time / 70);

    IF factor > 0 THEN
        IF movi_time - (factor * 70) > 30 THEN
            movi_time := movi_time + (factor * 15);
        ELSE
            factor := factor - 1;
            movi_time := movi_time + (factor * 15);
        END IF;
    END IF;

    hr := TRUNC(movi_time / 60);
    mi := movi_time - (hr * 60);

    DBMS_OUTPUT.PUT_LINE('Movie Title: ' || title || '. Running Time: ' || hr || ' hr' || mi || ' min');
END;
/


-- Call it from an anonymous block
DECLARE
    title VARCHAR2 (100);
BEGIN
    title:= '&title';
    Movie_Time(title);
END;
/

-----2-----

-- Procedure to Find N Top Rated movies

CREATE OR REPLACE PROCEDURE Top_Movies(N IN NUMBER) IS
    movie_count NUMBER;

BEGIN
    SELECT COUNT(*)
    INTO movie_count
    FROM Movie;
  
    IF N > movie_count THEN
        DBMS_OUTPUT.PUT_LINE('Error: Overflow');
        RETURN;
    END IF;

    movie_count := 0;
    FOR movie_rating IN (
        SELECT m.mov_id, m.mov_title, NVL(AVG(r.rev_stars),0) as avg_rating
        FROM Movie m LEFT JOIN Rating r ON m.mov_id = r.mov_id
        GROUP BY m.mov_id, m.mov_title
        ORDER BY avg_rating DESC
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Movie ID: ' || movie_rating.mov_id);
        DBMS_OUTPUT.PUT_LINE('Title: ' || movie_rating.mov_title);
        DBMS_OUTPUT.PUT_LINE('Average Rating: ' || ROUND(movie_rating.avg_rating, 2));
        DBMS_OUTPUT.PUT_LINE('------------------------');
        movie_count:= movie_count + 1;
        EXIT WHEN movie_count>= n;
    END LOOP;
END;
/

-- Call it from an anonymous block
DECLARE
    N NUMBER;
BEGIN
    N:= '&N';
    Top_Movies(N);
END;
/

-----3-----

--Procedure to find years between release date and current date
CREATE OR REPLACE PROCEDURE Year_Between(in_Date IN DATE, out_Difference OUT NUMBER) AS
    date_Current DATE;
    year_Difference NUMBER;
BEGIN
    date_Current := SYSDATE;

    SELECT TRUNC(MONTHS_BETWEEN(date_Current, in_Date) / 12)
    INTO year_Difference
    FROM DUAL;

    out_Difference := year_Difference;
END;
/

-- Function to Find Total Earning
CREATE OR REPLACE FUNCTION Yearly_Earning(movie_ID IN NUMBER) RETURN NUMBER IS
    total_earning NUMBER := 0;
    release_date DATE;
    date_difference NUMBER;

BEGIN
    SELECT MOV_RELEASEDATE INTO release_date
    FROM MOVIE
    WHERE MOV_ID = movie_ID;

    Year_Between(release_date, date_difference);

    SELECT SUM(REV_STARS * 10)
    INTO total_earning
    FROM RATING
    WHERE MOV_ID = movie_ID AND REV_STARS >= 6;

    total_earning := total_earning * date_difference;

    RETURN total_earning; -- Add this RETURN statement
END;
/

-- Call it from an anonymous block
DECLARE
    movie_id NUMBER;
    earnings NUMBER;
BEGIN
    movie_id := &movie_id;
    earnings := Yearly_Earning(movie_id);
    DBMS_OUTPUT.PUT_LINE('The earning for movie_id ' || movie_id || ' is: $' || earnings);
END;
/

-----4-----

--Function to Print Specific genre info
CREATE OR REPLACE FUNCTION Genre_Status(gen_id IN NUMBER)
RETURN VARCHAR2 AS
    status VARCHAR2(50);
    stars NUMBER;
    review_count NUMBER;
    total_info VARCHAR2(100);
    main_review NUMBER;
BEGIN
    SELECT reviewww INTO main_review
    FROM (
        SELECT GENRES.GEN_ID, COUNT(DISTINCT RATING.REV_ID) AS reviewww
        FROM GENRES, MTYPE, RATING
        WHERE GENRES.GEN_ID = MTYPE.GEN_ID AND MTYPE.MOV_ID = RATING.MOV_ID
        GROUP BY GENRES.GEN_ID
    )
    WHERE GEN_ID = gen_id;

    SELECT stara INTO stars
    FROM (
        SELECT GENRES.GEN_ID, AVG(NVL(RATING.REV_STARS, 0)) AS stara
        FROM GENRES, MTYPE, RATING
        WHERE GENRES.GEN_ID = MTYPE.GEN_ID AND MTYPE.MOV_ID = RATING.MOV_ID
        GROUP BY GENRES.GEN_ID
        ORDER BY GENRES.GEN_ID
    )
    WHERE GEN_ID = gen_id;

    SELECT AVG(review_cnt) INTO review_count
    FROM (
        SELECT COUNT(DISTINCT RATING.REV_ID) AS review_cnt
        FROM GENRES, MTYPE, RATING
        WHERE GENRES.GEN_ID = MTYPE.GEN_ID AND MTYPE.MOV_ID = RATING.MOV_ID
        GROUP BY MTYPE.GEN_ID
    );

    IF review_count < stars THEN
        status := 'Widely Watched';
    ELSIF review_count = stars THEN
        status := 'Highly Rated';
    ELSIF review_count > stars THEN
        status := 'People’s Favorite';
    ELSE
        status := 'So So';
    END IF;

    total_info := 'Status: ' || status || ' avg rating: ' || stars || ' review count: ' || main_review;

    RETURN total_info;
END;
/

-- Call it from an anonymous block
DECLARE
    gen_id_param NUMBER := 1;
    genre_status_result VARCHAR2;
BEGIN
    genre_status_result := Genre_Status(gen_id_param);
    DBMS_OUTPUT.PUT_LINE('Genre Status: ' || genre_status_result);
END;
/

-----5-----

CREATE OR REPLACE FUNCTION Frequent_Genre(yr1 IN NUMBER, yr2 IN NUMBER)
RETURN VARCHAR2 IS
    title VARCHAR2(20);
    counta NUMBER;
BEGIN
    SELECT GEN_TITLE, count_of_movies INTO title, counta
    FROM (
        SELECT GEN_TITLE, COUNT(MOVIE.MOV_ID) AS count_of_movies
        FROM MOVIE, MTYPE, GENRES
        WHERE MOVIE.MOV_ID = MTYPE.MOV_ID AND MTYPE.GEN_ID = GENRES.GEN_ID AND MOVIE.MOV_YEAR >= yr1 AND MOVIE.MOV_YEAR <= yr2
        GROUP BY GEN_TITLE
        ORDER BY count_of_movies DESC
    )
    WHERE ROWNUM = 1;

    RETURN title || ' ' || counta;
END;
/

-- Call it from an anonymous block
DECLARE
  result VARCHAR2(50);
BEGIN

  result := Frequent_Genre(1920, 2010);
  DBMS_OUTPUT.PUT_LINE('Most Frequent Genre: ' || result);
END;
/