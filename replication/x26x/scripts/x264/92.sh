#!/bin/sh

numb='93'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 4.2 --qblur 0.3 --qcomp 0.6 --vbv-init 0.4 --aq-mode 0 --b-adapt 0 --bframes 4 --crf 40 --keyint 270 --lookahead-threads 1 --min-keyint 30 --qp 50 --qpstep 4 --qpmin 0 --qpmax 66 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset placebo --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,2.5,1.1,1.1,4.2,0.3,0.6,0.4,0,0,4,40,270,1,30,50,4,0,66,48,3,2000,1:1,hex,show,placebo,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"