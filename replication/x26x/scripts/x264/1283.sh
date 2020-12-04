#!/bin/sh

numb='1284'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --intra-refresh --no-asm --weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 3.4 --qblur 0.2 --qcomp 0.9 --vbv-init 0.8 --aq-mode 1 --b-adapt 0 --bframes 2 --crf 30 --keyint 200 --lookahead-threads 2 --min-keyint 23 --qp 30 --qpstep 3 --qpmin 4 --qpmax 61 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset slow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,--intra-refresh,--no-asm,None,--weightb,1.5,1.0,1.3,3.4,0.2,0.9,0.8,1,0,2,30,200,2,23,30,3,4,61,48,1,2000,-1:-1,umh,show,slow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"