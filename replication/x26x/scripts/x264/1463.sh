#!/bin/sh

numb='1464'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 4.0 --qblur 0.2 --qcomp 0.8 --vbv-init 0.1 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 10 --keyint 280 --lookahead-threads 3 --min-keyint 24 --qp 40 --qpstep 5 --qpmin 4 --qpmax 60 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset veryslow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,0.0,1.2,1.2,4.0,0.2,0.8,0.1,2,2,10,10,280,3,24,40,5,4,60,28,3,1000,-2:-2,dia,show,veryslow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"