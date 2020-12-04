#!/bin/sh

numb='2162'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.3 --psy-rd 0.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.3 --aq-mode 1 --b-adapt 2 --bframes 0 --crf 45 --keyint 230 --lookahead-threads 3 --min-keyint 24 --qp 20 --qpstep 4 --qpmin 4 --qpmax 62 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset faster --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,2.5,1.4,1.3,0.4,0.3,0.8,0.3,1,2,0,45,230,3,24,20,4,4,62,38,3,2000,1:1,dia,show,faster,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"