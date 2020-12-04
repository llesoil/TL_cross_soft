#!/bin/sh

numb='1822'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.3 --psy-rd 4.2 --qblur 0.4 --qcomp 0.6 --vbv-init 0.8 --aq-mode 3 --b-adapt 1 --bframes 16 --crf 0 --keyint 260 --lookahead-threads 3 --min-keyint 26 --qp 0 --qpstep 3 --qpmin 4 --qpmax 67 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset slow --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,2.5,1.3,1.3,4.2,0.4,0.6,0.8,3,1,16,0,260,3,26,0,3,4,67,18,3,2000,-2:-2,hex,show,slow,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"