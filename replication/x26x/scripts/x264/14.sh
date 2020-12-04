#!/bin/sh

numb='15'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 4.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.8 --aq-mode 2 --b-adapt 1 --bframes 14 --crf 15 --keyint 250 --lookahead-threads 2 --min-keyint 27 --qp 30 --qpstep 5 --qpmin 4 --qpmax 67 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset veryslow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,1.0,1.6,1.0,4.0,0.2,0.6,0.8,2,1,14,15,250,2,27,30,5,4,67,28,2,2000,-1:-1,hex,crop,veryslow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"