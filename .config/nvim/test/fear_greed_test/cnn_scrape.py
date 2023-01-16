""" Scrape cnn news - html wrapper/helper """
__docformat__ = "numpy"


def get_user_agent() -> str:
    """
    Get a random useragent strings from a list of some recently used real browsers.

    Returns:
        str
        random useragent string
    """
    user_agent_str = [
        "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.10; rv:86.1) Gecko/20100101 Firefox/86.1",
        "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:86.1) Gecko/20100101 Firefox/86.1",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:82.1) Gecko/20100101 Firefox/82.1",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:86.0) Gecko/20100101 Firefox/86.0",
        "Mozilla/5.0 (Windows NT 10.0; WOW64; rv:86.0) Gecko/20100101 Firefox/86.0",
        "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.10; rv:83.0) Gecko/20100101 Firefox/83.0",
        "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:84.0) Gecko/20100101 Firefox/84.0",
    ]
    return random.choice(user_agent_str)


def get_html(url: str):
    """
    Wraps HTTP requests.get for testibility.
    Fake the user agent by changing the User-AGent header of the request and bypass such User-Agent based blocking scripts used by websites

    :param url:
    :type url: str

    returns:
        string
        HTML page
    """
    return requests.get(url, headers={"User-Agent": get_user_agent()}).text


# vim:set sw=4 ts=4 sts=4
