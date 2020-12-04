#!/bin/sh

numb='145'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.0 --psy-rd 2.4 --qblur 0.5 --qcomp 0.7 --vbv-init 0.4 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 45 --keyint 300 --lookahead-threads 0 --min-keyint 25 --qp 30 --qpstep 5 --qpmin 1 --qpmax 61 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset slow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,1.5,1.4,1.0,2.4,0.5,0.7,0.4,0,0,16,45,300,0,25,30,5,1,61,38,2,2000,-2:-2,umh,show,slow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"