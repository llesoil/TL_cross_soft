#!/bin/sh

numb='2562'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 4.2 --qblur 0.2 --qcomp 0.9 --vbv-init 0.1 --aq-mode 2 --b-adapt 0 --bframes 12 --crf 45 --keyint 300 --lookahead-threads 2 --min-keyint 26 --qp 20 --qpstep 5 --qpmin 4 --qpmax 63 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset placebo --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,3.0,1.5,1.2,4.2,0.2,0.9,0.1,2,0,12,45,300,2,26,20,5,4,63,48,4,1000,-2:-2,hex,show,placebo,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"