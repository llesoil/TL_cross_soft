#!/bin/sh

numb='2758'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 1.2 --qblur 0.3 --qcomp 0.9 --vbv-init 0.1 --aq-mode 1 --b-adapt 2 --bframes 8 --crf 35 --keyint 250 --lookahead-threads 2 --min-keyint 29 --qp 20 --qpstep 4 --qpmin 2 --qpmax 68 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset veryslow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.0,1.0,1.3,1.2,0.3,0.9,0.1,1,2,8,35,250,2,29,20,4,2,68,18,4,1000,-1:-1,hex,crop,veryslow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"