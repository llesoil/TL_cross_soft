#!/bin/sh

numb='1174'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 3.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.5 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 45 --keyint 300 --lookahead-threads 3 --min-keyint 25 --qp 10 --qpstep 3 --qpmin 3 --qpmax 61 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset veryslow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,3.0,1.3,1.0,3.6,0.2,0.7,0.5,2,2,10,45,300,3,25,10,3,3,61,38,5,2000,-1:-1,hex,show,veryslow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"