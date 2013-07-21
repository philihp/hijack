require 'hijack/script/base/base_dragonrealms_script'

class ScrapeScript < BaseDragonrealmsScript

  ALREADY_HOLDING = 'You are already holding'
  DONE_SCRAPING = 'clean as you can make it'
  NEED_MORE_MATERIAL = 'You need to be holding the material'
  NO_MERCHANT = 'There is no merchant'
  SCRAPE_SUCCESS = 'You scrape'
  SELL_SUCCESS = 'then hands you'
  WHAT_WERE_YOU = 'What were you'
  YOU_GET = 'You get'
  YOU_PUT = 'You put'

  GET_SCRAPER_PATTERN = [
    ALREADY_HOLDING,
    YOU_GET,
    WHAT_WERE_YOU,
  ].join('|')

  GET_SKIN_PATTERN = [
    ALREADY_HOLDING,
    NEED_MORE_MATERIAL,
    WHAT_WERE_YOU,
    YOU_GET,
  ].join('|')

  SCRAPE_PATTERN = [
    DONE_SCRAPING,
    SCRAPE_SUCCESS,
  ].join('|')

  SELL_PATTERN = [
    NO_MERCHANT,
    SELL_SUCCESS,
  ].join('|')

  STORE_SCRAPER_PATTERN = YOU_PUT

  def validate_args(args)
    args.length == 2 ||
    (config_skin_type && config_scraper_container)
  end

  def run(args)
    skin_type = args[0] || config_skin_type
    scraper_container = args[1] || config_scraper_container
    return unless get_scraper
    unless get_skin(skin_type)
      store_scraper(scraper_container)
      return
    end
    loop do
      match = wait_for_match(
        SCRAPE_PATTERN,
        "scrape my #{skin_type}"
      )
      case match
        when DONE_SCRAPING
          match = wait_for_match(
            SELL_PATTERN,
            "sell my #{skin_type}"
          )
          if match == NO_MERCHANT
            wait_for_match(
              'You drop',
              "drop my #{skin_type}"
            )
          end
          unless get_skin(skin_type)
            store_scraper(scraper_container)
            return
          end
        else
          sleep 10
      end
    end
  end

  private

  def config_scraper_container
    @config[:scrape_scraper_container]
  end

  def config_skin_type
    @config[:scrape_skin_type]
  end

  def get_scraper
    match = wait_for_match(
      GET_SCRAPER_PATTERN,
      'get my scraper'
    )
    match != WHAT_WERE_YOU
  end

  def get_skin(skin_type)
    match = wait_for_match(
      GET_SKIN_PATTERN,
      "get my #{skin_type}"
    )
    match != WHAT_WERE_YOU
  end

  def store_scraper(scraper_container)
    wait_for_match(
      STORE_SCRAPER_PATTERN,
      "put my scraper in my #{scraper_container}"
    )
  end

end