#!/bin/sh

numb='2924'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 2.2 --qblur 0.5 --qcomp 0.9 --vbv-init 0.6 --aq-mode 0 --b-adapt 2 --bframes 12 --crf 35 --keyint 240 --lookahead-threads 3 --min-keyint 20 --qp 20 --qpstep 3 --qpmin 1 --qpmax 69 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset veryslow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.5,1.5,1.3,2.2,0.5,0.9,0.6,0,2,12,35,240,3,20,20,3,1,69,18,3,2000,-2:-2,dia,crop,veryslow,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"