#!/bin/sh

numb='1058'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 1.4 --qblur 0.6 --qcomp 0.6 --vbv-init 0.2 --aq-mode 1 --b-adapt 2 --bframes 6 --crf 50 --keyint 210 --lookahead-threads 2 --min-keyint 24 --qp 40 --qpstep 3 --qpmin 1 --qpmax 67 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset slow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,2.5,1.2,1.3,1.4,0.6,0.6,0.2,1,2,6,50,210,2,24,40,3,1,67,48,4,2000,-1:-1,hex,show,slow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"