#!/bin/sh

numb='776'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 4.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.6 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 20 --keyint 300 --lookahead-threads 4 --min-keyint 27 --qp 50 --qpstep 5 --qpmin 3 --qpmax 62 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset slow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,2.0,1.3,1.4,4.8,0.5,0.8,0.6,3,2,0,20,300,4,27,50,5,3,62,28,4,2000,-1:-1,hex,show,slow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"