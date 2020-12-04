#!/bin/sh

numb='244'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 5.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.8 --aq-mode 0 --b-adapt 1 --bframes 6 --crf 20 --keyint 250 --lookahead-threads 1 --min-keyint 24 --qp 20 --qpstep 3 --qpmin 2 --qpmax 68 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset veryslow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,3.0,1.1,1.2,5.0,0.4,0.8,0.8,0,1,6,20,250,1,24,20,3,2,68,28,3,1000,-1:-1,dia,crop,veryslow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"