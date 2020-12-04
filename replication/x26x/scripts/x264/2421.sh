#!/bin/sh

numb='2422'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 1.0 --qblur 0.5 --qcomp 0.9 --vbv-init 0.5 --aq-mode 1 --b-adapt 2 --bframes 16 --crf 20 --keyint 260 --lookahead-threads 2 --min-keyint 29 --qp 20 --qpstep 5 --qpmin 2 --qpmax 65 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset fast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,2.5,1.0,1.0,1.0,0.5,0.9,0.5,1,2,16,20,260,2,29,20,5,2,65,18,5,1000,-1:-1,hex,show,fast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"