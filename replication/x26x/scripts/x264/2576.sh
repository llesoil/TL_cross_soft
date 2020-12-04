#!/bin/sh

numb='2577'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 4.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.4 --aq-mode 2 --b-adapt 0 --bframes 2 --crf 20 --keyint 280 --lookahead-threads 2 --min-keyint 27 --qp 30 --qpstep 3 --qpmin 0 --qpmax 66 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset slow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,2.5,1.0,1.2,4.8,0.3,0.7,0.4,2,0,2,20,280,2,27,30,3,0,66,28,1,2000,-1:-1,hex,show,slow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"