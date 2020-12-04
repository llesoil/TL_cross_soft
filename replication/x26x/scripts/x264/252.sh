#!/bin/sh

numb='253'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 1.4 --qblur 0.5 --qcomp 0.6 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 6 --crf 25 --keyint 300 --lookahead-threads 1 --min-keyint 20 --qp 50 --qpstep 3 --qpmin 2 --qpmax 64 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset faster --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,1.5,1.6,1.1,1.4,0.5,0.6,0.3,3,1,6,25,300,1,20,50,3,2,64,38,5,2000,-2:-2,hex,crop,faster,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"