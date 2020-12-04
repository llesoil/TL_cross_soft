#!/bin/sh

numb='1698'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.1 --psy-rd 4.2 --qblur 0.4 --qcomp 0.7 --vbv-init 0.7 --aq-mode 0 --b-adapt 2 --bframes 12 --crf 35 --keyint 270 --lookahead-threads 1 --min-keyint 25 --qp 20 --qpstep 4 --qpmin 0 --qpmax 60 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset medium --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,1.5,1.2,1.1,4.2,0.4,0.7,0.7,0,2,12,35,270,1,25,20,4,0,60,18,6,1000,-2:-2,dia,crop,medium,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"