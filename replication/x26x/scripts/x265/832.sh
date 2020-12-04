#!/bin/sh

numb='833'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 2.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.2 --aq-mode 2 --b-adapt 1 --bframes 4 --crf 35 --keyint 290 --lookahead-threads 0 --min-keyint 30 --qp 0 --qpstep 3 --qpmin 0 --qpmax 66 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset slower --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,0.0,1.4,1.3,2.8,0.5,0.8,0.2,2,1,4,35,290,0,30,0,3,0,66,28,2,2000,-2:-2,umh,show,slower,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"