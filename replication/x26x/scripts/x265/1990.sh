#!/bin/sh

numb='1991'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 3.2 --qblur 0.6 --qcomp 0.8 --vbv-init 0.4 --aq-mode 2 --b-adapt 1 --bframes 2 --crf 5 --keyint 290 --lookahead-threads 2 --min-keyint 27 --qp 40 --qpstep 3 --qpmin 0 --qpmax 67 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset superfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,1.0,1.1,1.2,3.2,0.6,0.8,0.4,2,1,2,5,290,2,27,40,3,0,67,18,3,2000,-2:-2,hex,show,superfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"