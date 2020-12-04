#!/bin/sh

numb='681'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 1.0 --qblur 0.6 --qcomp 0.9 --vbv-init 0.0 --aq-mode 3 --b-adapt 2 --bframes 16 --crf 10 --keyint 240 --lookahead-threads 0 --min-keyint 20 --qp 30 --qpstep 4 --qpmin 4 --qpmax 62 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset slow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,2.5,1.3,1.0,1.0,0.6,0.9,0.0,3,2,16,10,240,0,20,30,4,4,62,38,5,2000,1:1,hex,show,slow,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"