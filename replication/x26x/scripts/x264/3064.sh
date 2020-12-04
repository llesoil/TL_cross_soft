#!/bin/sh

numb='3065'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 3.0 --qblur 0.6 --qcomp 0.6 --vbv-init 0.2 --aq-mode 1 --b-adapt 0 --bframes 4 --crf 25 --keyint 230 --lookahead-threads 3 --min-keyint 22 --qp 10 --qpstep 5 --qpmin 3 --qpmax 69 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset placebo --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,3.0,1.1,1.1,3.0,0.6,0.6,0.2,1,0,4,25,230,3,22,10,5,3,69,38,5,2000,-2:-2,hex,show,placebo,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"