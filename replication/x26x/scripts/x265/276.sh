#!/bin/sh

numb='277'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 3.0 --qblur 0.6 --qcomp 0.9 --vbv-init 0.1 --aq-mode 2 --b-adapt 2 --bframes 16 --crf 50 --keyint 220 --lookahead-threads 0 --min-keyint 27 --qp 30 --qpstep 3 --qpmin 4 --qpmax 61 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset placebo --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.3,1.0,3.0,0.6,0.9,0.1,2,2,16,50,220,0,27,30,3,4,61,38,3,2000,-1:-1,umh,show,placebo,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"