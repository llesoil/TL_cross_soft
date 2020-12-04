#!/bin/sh

numb='1024'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 2.4 --qblur 0.2 --qcomp 0.9 --vbv-init 0.3 --aq-mode 1 --b-adapt 0 --bframes 16 --crf 45 --keyint 220 --lookahead-threads 4 --min-keyint 26 --qp 10 --qpstep 5 --qpmin 2 --qpmax 60 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset slower --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,2.0,1.1,1.2,2.4,0.2,0.9,0.3,1,0,16,45,220,4,26,10,5,2,60,38,2,2000,-1:-1,hex,crop,slower,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"